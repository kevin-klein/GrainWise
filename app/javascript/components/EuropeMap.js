import { ScaleControl, MapContainer, TileLayer, useMapEvents, useMap, useMapEvent, Rectangle, Marker, Popup } from 'react-leaflet'
import React from 'react'
import { useEventHandlers } from '@react-leaflet/core'
// import { Radar } from 'react-chartjs-2'
import LeafletMarker from './LeafletMarker'
import { GeoJSON } from 'react-leaflet/GeoJSON'

function Markers ({ sites }) {
  const [zoom, setZoom] = React.useState(0)

  useMapEvents({
    zoomend: (e) => {
      setZoom(e.target._zoom)
    }
  })

  const markers = sites.map(site => {
    return (
      <Marker key={site.id} position={[site.lat, site.lon]}>
        <Popup>
          Site: <a href='' disabled>{site.name}</a>
        </Popup>
      </Marker>
    )
  })

  return (
    <>
      {markers}
    </>
  )
}

const POSITION_CLASSES = {
  bottomleft: 'leaflet-bottom leaflet-left',
  bottomright: 'leaflet-bottom leaflet-right',
  topleft: 'leaflet-top leaflet-left',
  topright: 'leaflet-top leaflet-right'
}

const BOUNDS_STYLE = { weight: 1 }

function MinimapBounds ({ parentMap, zoom }) {
  const minimap = useMap()

  // Clicking a point on the minimap sets the parent's map center
  const onClick = React.useCallback(
    (e) => {
      parentMap.setView(e.latlng, parentMap.getZoom())
    },
    [parentMap]
  )
  useMapEvent('click', onClick)

  // Keep track of bounds in state to trigger renders
  const [bounds, setBounds] = React.useState(parentMap.getBounds())
  const onChange = React.useCallback(() => {
    setBounds(parentMap.getBounds())
    // Update the minimap's view to match the parent map's center and zoom
    minimap.setView(parentMap.getCenter(), zoom)
  }, [minimap, parentMap, zoom])

  // Listen to events on the parent map
  const handlers = React.useMemo(() => ({ move: onChange, zoom: onChange }), [])
  useEventHandlers({ instance: parentMap }, handlers)

  return <Rectangle bounds={bounds} pathOptions={BOUNDS_STYLE} />
}

function MinimapControl ({ position, zoom }) {
  const parentMap = useMap()
  const mapZoom = zoom || 2

  // Memoize the minimap so it's not affected by position changes
  const minimap = React.useMemo(
    () => (
      <MapContainer
        style={{ height: 100, width: 140 }}
        center={parentMap.getCenter()}
        zoom={mapZoom}
        dragging={false}
        doubleClickZoom={false}
        scrollWheelZoom={false}
        attributionControl={false}
        zoomControl={false}
      >
        <TileLayer url='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' />
        <MinimapBounds parentMap={parentMap} zoom={mapZoom} />
      </MapContainer>
    ),
    []
  )

  const positionClass =
    (position && POSITION_CLASSES[position]) || POSITION_CLASSES.topright
  return (
    <div className={positionClass}>
      <div className='leaflet-control leaflet-bar'>{minimap}</div>
    </div>
  )
}

function NorthArrowControl ({ position }) {
  const positionClass =
  (position && POSITION_CLASSES[position]) || POSITION_CLASSES.topright
  return (
    <div className={positionClass} style={{ left: 5, bottom: 5 }}>
      <div style={{ backgroundColor: 'white', padding: 5, borderRadius: 5 }}>
        <img src='/arrow.png' style={{ width: 50 }} />
      </div>
    </div>
  )
}

export default function EuropeMap ({ sites }) {
  return (
    <div style={{ height: 500 }}>
      <MapContainer scrollWheelZoom style={{ height: '100%' }} center={[49.555, 16]} zoom={4}>
        <TileLayer
          attribution='Tiles &copy; Esri &mdash; Source: Esri'
          url='https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}'
        />
        <Markers sites={sites} />
        <MinimapControl position='topright' />
        <ScaleControl position='bottomright' />
        <NorthArrowControl position='topleft' />
      </MapContainer>
    </div>
  )
}
