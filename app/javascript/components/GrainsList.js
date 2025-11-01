import useSWR from 'swr'
import React from 'react'
import BoxResizer from './BoxResizer'

const fetcher = (...args) => fetch(...args).then(res => res.json())

function useGrains ({ page, site, species }) {
  const { data, error, isLoading, mutate } = useSWR(`/grains.json?page=${page}&site_id=${site}&species_id=${species}`, fetcher)

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

function useSpecies () {
  const { data, error, isLoading } = useSWR('/strains.json', fetcher)

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

function SpeciesFilter ({ species, setSpecies }) {
  const { sites, isLoading, isError } = useSpecies()

  if (isError) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  return (
    <div className='form-group select required search_site_id'>
      <label className='select required' htmlFor='search_site_id'>Species</label>
      <select value={species} onChange={(evt) => setSpecies(evt.target.value)} className='form-control select required' name='search[site_id]' id='search_site_id'>
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
            {grain.id} - {grain.identifier}
          </a>
        )
      }
      )}
    </ul>
  )
}

function range (size, startAt) {
  return [...Array(size).keys()].map(i => i + startAt)
}

function Pagination ({ page, setPage, pagination }) {
  const pages = range(6, page - 3).filter(i => i > 0 && i <= pagination.pages)

  return (
    <nav aria-label='Page navigation example'>
      <ul className='pagination'>
        <li className='page-item'><a className='page-link' href='#'>Previous</a></li>
        {pages.map(currentPage => (
          <li className={`page-item ${page === currentPage ? 'active' : ''}`} key={currentPage}><a className='page-link' onClick={() => setPage(currentPage)} href='#'>{currentPage}</a></li>
        ))}
        <li className='page-item'><a className='page-link' href='#' onClick={(evt) => { evt.preventDefault(); setPage(page + 1)} }>Next</a></li>
      </ul>
    </nav>
  )
}

function defaultGrainView (grain) {
  const views = ['dorsal', 'lateral', 'ventral']

  for (const view of views) {
    if (grain[view] !== undefined) {
      return view
    }
  }
}

function ViewTabs ({ grain, onUpdateGrains }) {
  const [view, setView] = React.useState(defaultGrainView(grain))

  const figure = grain[view]

  return (
    <div>
      <ul className='nav nav-tabs'>
        <li className='nav-item'>
          <a className={`nav-link ${grain.dorsal === undefined ? 'disabled' : ''} ${view === 'dorsal' ? 'active' : ''}`} onClick={() => setView('dorsal')} href='#'>Dorsal</a>
        </li>
        <li className='nav-item'>
          <a className={`nav-link ${grain.lateral === undefined ? 'disabled' : ''} ${view === 'lateral' ? 'active' : ''}`} onClick={() => setView('lateral')} aria-current='page' href='#'>Lateral</a>
        </li>
        <li className='nav-item'>
          <a className={`nav-link ${grain.ventral === undefined ? 'disabled' : ''} ${view === 'ventral' ? 'active' : ''}`} onClick={() => setView('ventral')} aria-current='page' href='#'>Ventral</a>
        </li>
        <li className='nav-item'>
          <a className={`nav-link ${grain.ts === undefined ? 'disabled' : ''} ${view === 'TS' ? 'active' : ''}`} onClick={() => setView('ts')} aria-current='page' href='#'>T.S.</a>
        </li>
      </ul>

      {figure !== undefined && <BoxResizer view={view} onUpdateGrains={onUpdateGrains} key={figure?.id} grain={figure} image={figure.image} scale={figure.scale} />}
    </div>
  )

  // dorsal: length/width
  // lateral: thickness/length
  // ventral: length/width
}

export default function GrainList ({export_grains_path, export_outlines_grains_path}) {
  const urlParams = new URL(document.location.toString()).searchParams
  const urlSiteId = urlParams.get('site_id')

  const [page, setPage] = React.useState(1)
  const [selected, setSelected] = React.useState(null)
  const [site, setSite] = React.useState(urlSiteId)
  const [species, setSpecies] = React.useState(undefined)
  const { grains, isLoading, isError, mutate } = useGrains({ page, site, species })

  React.useEffect(() => {
    if (grains !== undefined && selected === null && grains.grains.length > 0) {
      setSelected(grains.grains[0].id)
    }
  }, [grains?.grains])

  function onUpdateGrains () {
    mutate()
  }

  if (isError) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  const selectedGrain = grains.grains.filter(grain => grain.id === selected)[0]

  return (
    <div className='row'>
      <div className='col-md-12'>
        <a className="btn btn-success mb-4 me-3" href={export_grains_path + `?site_id=${site}&species_id=${species}`}>Export Data</a>
        <a className="btn btn-success mb-4" href={export_outlines_grains_path + `?site_id=${site}&species_id=${species}`}>Export Outlines</a>
      </div>
      <div className='col-md-12 mb-2'>
        <GrainFilter site={site} setSite={setSite} />
        <SpeciesFilter species={species} setSpecies={setSpecies} />
      </div>

      <div className='col-md-3'>
        <GrainListView grains={grains.grains} selected={selected} setSelected={setSelected} />
        <div className='mt-3'>
          <Pagination page={page} setPage={setPage} pagination={grains.pagination} />
        </div>
      </div>

      <div className='col-md-9'>
        {selected !== null && selectedGrain !== undefined && selected !== undefined && <ViewTabs onUpdateGrains={onUpdateGrains} grain={selectedGrain} key={selected} />}
      </div>
    </div>
  )
}
