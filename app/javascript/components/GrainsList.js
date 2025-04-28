import useSWR from 'swr'
import React from 'react'
import BoxResizer from './BoxResizer'

const fetcher = (...args) => fetch(...args).then(res => res.json())

function useGrains ({ page, site }) {
  const { data, error, isLoading, mutate } = useSWR(`/grains.json?page=${page}&site_id=${site}`, fetcher)

  return {
    grains: data,
    isLoading,
    isError: error,
    mutate
  }
}

function useSites () {
  const { data, error, isLoading } = useSWR('/sites.json', fetcher)

  return {
    sites: data,
    isLoading,
    isError: error
  }
}

function GrainFilter ({ site, setSite }) {
  const { sites, isLoading, isError } = useSites()

  if (isError) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  return (
    <div className='form-group select required search_site_id'>
      <label className='select required' htmlFor='search_site_id'>Site</label>
      <select value={site} onChange={(evt) => setSite(evt.target.value)} className='form-control select required' name='search[site_id]' id='search_site_id'>
        <option value={undefined} label='' />
        {sites.map(site => (
          <option key={site.id} value={site.id} label={site.name} />
        ))}
      </select>
    </div>
  )
}

function GrainListView ({ grains, selected, setSelected }) {
  return (
    <ul className='list-group'>
      {grains.map(grain => {
        return (
          <a href='#' onClick={() => setSelected(grain.id)} className={`list-group-item list-group-item-action ${selected === grain.id ? 'active' : ''}`} key={grain.id}>
            {grain.identifier}
          </a>
        )
      }
      )}
    </ul>
  )
}

function ViewTabs ({ grain, onUpdateGrains }) {
  const [view, setView] = React.useState(grain.ventral !== undefined ? 'ventral' : 'dorsal')

  const figure = view === 'ventral' ? grain.ventral : grain.dorsal

  return (
    <div>
      <ul className='nav nav-tabs'>
        <li className='nav-item'>
          <a className={`nav-link ${view === 'ventral' ? 'active' : ''}`} aria-current='page' href='#'>Ventral</a>
        </li>
        <li className='nav-item'>
          <a className={`nav-link ${view === 'dorsal' ? 'active' : ''}`} href='#'>Dorsal</a>
        </li>
      </ul>

      {figure !== undefined && <BoxResizer onUpdateGrains={onUpdateGrains} key={figure?.id} grain={figure} image={figure.image} scale={figure.scale} />}
    </div>
  )
}

export default function GrainList (params) {
  const [page, setPage] = React.useState(1)
  const [selected, setSelected] = React.useState(null)
  const [site, setSite] = React.useState(undefined)
  const { grains, isLoading, isError, mutate } = useGrains({ page, site })

  React.useEffect(() => {
    if (grains !== undefined && selected === null && grains.length > 0) {
      setSelected(grains[0].id)
    }
  }, [grains])

  function onUpdateGrains () {
    mutate()
  }

  if (isError) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  return (
    <div className='row'>
      <div className='col-md-12'>
        <GrainFilter site={site} setSite={setSite} />
      </div>

      <div className='col-md-3'>
        <GrainListView grains={grains} selected={selected} setSelected={setSelected} />
      </div>

      <div className='col-md-9'>
        {selected !== null && selected !== undefined && <ViewTabs onUpdateGrains={onUpdateGrains} grain={grains.filter(grain => grain.id === selected)[0]} key={selected} />}
        {/* {selected !== null && <BoxResizer key={selected?.id} grain={selected} image={selected.image} scale={selected.scale} />} */}
      </div>
    </div>
  )
}
