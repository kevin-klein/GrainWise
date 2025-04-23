import useSWR from 'swr'
import React from 'react'
import BoxResizer from './BoxResizer'

const fetcher = (...args) => fetch(...args).then(res => res.json())

function useGrains ({ page }) {
  const { data, error, isLoading } = useSWR(`/grains.json?page=${page}`, fetcher)

  return {
    grains: data,
    isLoading,
    isError: error
  }
}

function useSites () {
  const { data, error, isLoading } = useSWR('/sites', fetcher)

  return {
    sites: data,
    isLoading,
    isError: error
  }
}

function GrainFilter () {
  const { sites, isLoading, isError } = useSites()

  return (
    <div className='form-group select required search_site_id'>
      <label className='select required' htmlFor='search_site_id'>Site</label>
      <select className='form-control select required' name='search[site_id]' id='search_site_id'>
        <option value='' label=' ' />
      </select>
    </div>
  )
}

function GrainListView ({ grains, selected, setSelected }) {
  return (
    <ul className='list-group'>
      {grains.map(grain => {
        return (
          <a href='#' onClick={() => setSelected(grain)} className={`list-group-item list-group-item-action ${selected?.id === grain.id ? 'active' : ''}`} key={grain.id}>
            {grain.identifier}
          </a>
        )
      }
      )}
    </ul>
  )
}

export default function GrainList (params) {
  const [page, setPage] = React.useState(1)
  const [selected, setSelected] = React.useState(null)
  const { grains, isLoading, isError } = useGrains({ page })

  React.useEffect(() => {
    if (grains !== undefined && selected === null) {
      setSelected(grains[0])
    }
  }, [grains])

  if (isError) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  return (
    <div className='row'>
      <div className='col-md-12'>
        <GrainFilter />
      </div>

      <div className='col-md-3'>
        <GrainListView grains={grains} selected={selected} setSelected={setSelected} />
      </div>

      <div className='col-md-9'>
        {selected !== null && <BoxResizer grain={selected} image={selected.image} scale={selected.scale} />}
      </div>
    </div>
  )
}
