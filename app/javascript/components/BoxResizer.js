import React from 'react'
import { Wizard, useWizard } from 'react-use-wizard'
import Select from 'react-select'
import { useFigureStore } from './store'
import { Group, Stage, Layer, Circle, Image, Rect, Line, Transformer, Arrow, Shape } from 'react-konva'
import useImage from 'use-image'
import ManualContour, { calculateControlPoints } from './ManualContour'

function rotatePoint (x, y, figure) {
  const centerX = (figure.x2 + figure.x1) / 2
  const centerY = (figure.y2 + figure.y1) / 2
  let newX = (x - centerX) * Math.cos(-figure.bounding_box_angle) - (y - centerY) * Math.sin(-figure.bounding_box_angle)
  let newY = (x - centerX) * Math.sin(-figure.bounding_box_angle) + (y - centerY) * Math.cos(-figure.bounding_box_angle)
  newX = newX + centerX
  newY = newY + centerY

  return {
    x: newX,
    y: newY
  }
}

export function Box ({ onChangeFigure, onDraggingStart, active, figure, setActive }) {
  const { id, x1, y1, x2, y2, typeName } = figure

  let color = 'black'
  if (active === id) {
    color = '#F44336'
  }
  const isSelected = active === id
  const shapeRef = React.useRef()
  const trRef = React.useRef()

  React.useEffect(() => {
    if (isSelected && !figure.manual_bounding_box && typeName !== 'Spine') {
      trRef.current.nodes([shapeRef.current])
      trRef.current.getLayer().batchDraw()
    }
  }, [isSelected])

  if (figure.manual_bounding_box) {
    return <ManualContour onChangeFigure={onChangeFigure} active={active} onDraggingStart={onDraggingStart} figure={figure} color={color} />
  }

  return (
    <>
      <Line
        points={figure.contour?.map(([x, y]) => [figure.x1 + x, figure.y1 + y]).flat()}
        closed
        fill='red'
        stroke='transparent'
      />

      <Rect
        fill={null}
        ref={shapeRef}
        stroke={color}
        fillEnabled={false}
        strokeWidth={3}
        x={x1}
        y={y1}
        width={x2 - x1}
        height={y2 - y1}
        onClick={() => setActive(id)}
        onTap={() => setActive(id)}
        onTransformEnd={(e) => {
          const node = shapeRef.current
          const scaleX = node.scaleX()
          const scaleY = node.scaleY()

          node.scaleX(1)
          node.scaleY(1)

          const width = node.width() * scaleX
          const height = node.height() * scaleY

          onChangeFigure(figure.id, {
            ...figure,
            x1: node.x(),
            y1: node.y(),
            x2: node.x() + width,
            y2: node.y() + height
          })
        }}
      />

      {isSelected && typeName !== 'Spine' && (
        <Transformer
          ref={trRef}
          rotateEnabled={false}
          keepRatio={false}
          boundBoxFunc={(oldBox, newBox) => {
            if (newBox.width < 5 || newBox.height < 5) {
              return oldBox
            }
            return newBox
          }}
        />
      )}
    </>
  )
}

function NewFigureDialog ({ closeDialog, addFigure }) {
  const [type, setType] = React.useState('Spine')

  return (
    <div className='modal d-block' aria-hidden='false'>
      <div className='modal-dialog'>
        <div className='modal-content'>
          <div className='modal-header'>
            <h1 className='modal-title fs-5' id='exampleModalLabel'>New Figure</h1>
            <button type='button' onClick={closeDialog} className='btn-close' data-bs-dismiss='modal' aria-label='Close' />
          </div>
          <div className='modal-body'>
            <form>
              <div className='input-group mb-3'>
                <select value={type} onChange={evt => setType(evt.target.value)} className='form-select' aria-label='Default select example'>
                  <option value='Spine'>Spine</option>
                  <option value='SkeletonFigure'>Skeleton</option>
                  <option value='Scale'>Scale</option>
                  <option value='GraveCrossSection'>Grave Cross Section</option>
                  <option value='Arrow'>Arrow</option>
                  <option value='Good'>Artefact</option>
                </select>
              </div>
            </form>
          </div>
          <div className='modal-footer'>
            <button type='button' onClick={closeDialog} className='btn btn-secondary' data-bs-dismiss='modal'>Close</button>
            <button type='button' onClick={() => { addFigure(type); closeDialog() }} className='btn btn-primary'>Create</button>
          </div>
        </div>
      </div>
    </div>
  )
}

function Canvas ({ divRef, image, figures, grain, onDraggingStart, currentEditBox, setCurrentFigure, onChangeFigure }) {
  const [dimensions, setDimensions] = React.useState({
    width: 0,
    height: 0
  })
  const [stageScale, setStageScale] = React.useState(1)
  const [stageX, setStageX] = React.useState(0)
  const [stageY, setStageY] = React.useState(0)
  React.useEffect(() => {
    setDimensions({
      width: divRef.current.offsetWidth,
      height: (divRef.current.offsetWidth / image.width) * image.height
    })
    setStageScale(divRef.current.offsetWidth / image.width)
  }, [])
  const [imageNode] = useImage(image.href)

  function handleWheel (e) {
    e.evt.preventDefault()

    const scaleBy = 1.3
    const stage = e.target.getStage()
    const oldScale = stage.scaleX()
    const mousePointTo = {
      x: stage.getPointerPosition().x / oldScale - stage.x() / oldScale,
      y: stage.getPointerPosition().y / oldScale - stage.y() / oldScale
    }

    const newScale = e.evt.deltaY < 0 ? oldScale * scaleBy : oldScale / scaleBy

    setStageScale(newScale)
    setStageX(-(mousePointTo.x - stage.getPointerPosition().x / newScale) * newScale)
    setStageY(-(mousePointTo.y - stage.getPointerPosition().y / newScale) * newScale)
  }

  return (
    <Stage
      onWheel={handleWheel}
      scaleX={stageScale}
      scaleY={stageScale}
      x={stageX}
      y={stageY}
      width={dimensions.width}
      draggable
      height={dimensions.height}
    >
      <Layer>
        <Image
          width={image.width}
          height={image.height}
          image={imageNode}
          x={0}
          y={0}
        />
        <Line
          x={0}
          y={0}
          points={grain.contour.flat()}
          closed
          fill='#3F51B588'
          stroke='black'
        />
        {Object.values(figures).map(figure => <Box onChangeFigure={onChangeFigure} canvas={null} key={figure.id} onDraggingStart={onDraggingStart} setActive={setCurrentFigure} active={currentEditBox} figure={figure} />)}
      </Layer>
    </Stage>
  )
}

export default function BoxResizer ({ onUpdateGrains, grain, scale, sites, image, page, view }) {
  const [currentFigure, setCurrentFigure] = React.useState(null)

  const [rendering, setRendering] = React.useState('boxes')
  const [draggingState, setDraggingState] = React.useState(null)
  const [creatingNewFigure, setCreatingNewFigure] = React.useState(false)

  const [currentScale, setCurrentScale] = React.useState(scale)

  const divRef = React.useRef(null)

  const token =
      document.querySelector('[name=csrf-token]').content

  function currentEditBoxActiveClass (figure) {
    if (figure === undefined) {
      return ''
    }
    if (figure.id === currentFigure) {
      return ' active'
    }
  }

  function createNewFigure () {
    setCreatingNewFigure(true)
  }

  async function removeEditBox (id) {
    const response = await fetch(`/figures/${id}.json`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json'
      }
    })
    if (response.ok) {
      removeFigure(figures[id])
    } else {
      return Promise.reject(response)
    }
  }

  function onChangeFigure (id, figure) {
    // setFigures(Object.values(figures).map((currentFigure) => {
    //   if (currentFigure.id === figure.id) {
    //     return figure
    //   } else {
    //     return currentFigure
    //   }
    // }))
    setCurrentScale(figure)
  }

  function setManualBoundingBox (figure, checked) {
    if (checked && figure.bounding_box_angle === null) {
      const centerX = (figure.x1 + figure.x2) / 2
      const centerY = (figure.y1 + figure.y2) / 2
      const angle = 0
      const width = figure.x2 - figure.x1
      const height = figure.y2 - figure.y1
      onChangeFigure(figure.id, {
        ...figure,
        manual_bounding_box: checked,
        bounding_box_center_x: centerX,
        bounding_box_center_y: centerY,
        bounding_box_angle: angle,
        bounding_box_width: width,
        bounding_box_height: height
      })
    } else {
      onChangeFigure(figure.id, { ...figure, manual_bounding_box: checked })
    }
  }

  function onDraggingStart (evt, data) {
    const figure = data.figure
    setCurrentFigure(figure.id)
    let svgPoint = canvasRef.current.createSVGPoint()
    svgPoint.x = evt.clientX
    svgPoint.y = evt.clientY
    svgPoint = svgPoint.matrixTransform(canvasRef.current.getScreenCTM().inverse())

    setDraggingState({
      point: svgPoint,
      x1: svgPoint.x - figure.x1,
      y1: svgPoint.y - figure.y1,
      x2: svgPoint.x - figure.x2,
      y2: svgPoint.y - figure.y2,
      data
    })
  }

  async function createFigure (type) {
    let newFigure = null

    newFigure = { typeName: type, grain_figure_id: grain.id, x1: 0, y1: 0, x2: 100, y2: 100 }

    const response = await fetch('/figures.json', {
      method: 'POST',
      body: JSON.stringify({
        figure: {
          x1: newFigure.x1,
          x2: newFigure.x2,
          y1: newFigure.y1,
          y2: newFigure.y2,
          type: newFigure.typeName,
          parent_id: grain.id,
          upload_item_id: grain.upload_item_id,
          upload_id: grain.upload_id
        }
      }),
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json'
      }
    })
    if (response.ok) {
      newFigure = await response.json()
      console.log(newFigure)
      setCurrentScale(newFigure)
      setCurrentFigure(newFigure.id)
    } else {
      return Promise.reject(response)
    }
  }

  async function onUpdateFigure () {
    const response = await fetch(`/figures/${scale.id}.json`, {
      method: 'PUT',
      body: JSON.stringify({
        figure: {
          x1: currentScale.x1,
          x2: currentScale.x2,
          y1: currentScale.y1,
          y2: currentScale.y2,
          page_id: currentScale.page_id,
          type: currentScale.typeName,
          parent_id: grain.id
        }
      }),
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json'
      }
    })
    if (response.ok) {
      const newFigure = await response.json()
      setCurrentScale(newFigure.figure)
      setCurrentFigure(newFigure.figure.id)
      onUpdateGrains()
    } else {
      return Promise.reject(response)
    }
  }

  let labels = []
  if (view === 'ventral') {
    labels = ['Width', 'Length']
  } else if (view === 'dorsal') {
    labels = ['Width', 'Length']
  } else {
    labels = ['Thickness', 'Length']
  }

  return (
    <>
      {creatingNewFigure && <NewFigureDialog addFigure={createFigure} closeDialog={() => setCreatingNewFigure(false)} />}
      <div className='row'>
        <div className='col-md-8 card' ref={divRef}>
          <Canvas
            grain={grain}
            setCurrentFigure={setCurrentFigure}
            divRef={divRef}
            image={image}
            figures={currentScale !== undefined ? [currentScale] : []}
            onDraggingStart={onDraggingStart}
            currentEditBox={currentFigure}
            onChangeFigure={onChangeFigure}
          />
        </div>

        <div className='col-md-4'>
          <div className='card'>
            <div className='card-body'>
              <h5 className='card-title'>Edit Grain Photograph</h5>
              <div className='card-text'>

                <table className='table'>
                  <tbody>
                    <tr>
                      <td>{labels[0]}</td>
                      <td>{grain.width}</td>
                    </tr>
                    <tr>
                      <td>{labels[1]}</td>
                      <td>{grain.height}</td>
                    </tr>
                  </tbody>
                </table>

                <ul className='list-group'>
                  {scale !== undefined && (
                    <div
                      onClick={() => { setCurrentFigure(currentScale.id) }}
                      className={`list-group-item list-group-item-action d-flex justify-content-between align-items-start ${currentEditBoxActiveClass(scale)}`}
                    >
                      <div className='ms-2 me-auto'>
                        <div className='fw-bold'>Scale</div>
                      </div>
                    </div>
                  )}

                  <div
                    onClick={() => { setCurrentFigure(currentScale.id) }}
                    className={`list-group-item list-group-item-action d-flex justify-content-between align-items-start ${currentEditBoxActiveClass(grain)}`}
                  >
                    <div className='ms-2 me-auto'>
                      <div className='fw-bold'>Grain {grain.identifier}</div>
                    </div>
                  </div>
                  <div className='row mb-3 mt-3'>
                    <div className='form-check ms-3'>
                      <input
                        className='form-check-input disabled'
                        type='checkbox'
                        disabled
                        checked={scale?.manual_bounding_box}
                        onChange={(evt) => { setManualBoundingBox(scale, evt.target.checked) }}
                      />
                      <label className='form-check-label'>
                        manual bounding box
                      </label>
                    </div>
                  </div>
                  <a
                    href='#'
                    onClick={(evt) => { evt.preventDefault(); createNewFigure() }}
                    className={`list-group-item list-group-item-action d-flex justify-content-between align-items-start ${currentScale !== undefined ? 'disabled' : ''}`}
                  >
                    <div className='ms-2 me-auto'>
                      <div className='fw-bold'>New Figure</div>
                    </div>
                  </a>
                </ul>
              </div>
              <input value='Save' onClick={(evt) => { evt.preventDefault(); onUpdateFigure() }} type='submit' className='btn btn-primary card-link mt-1' />
            </div>
          </div>
        </div>
      </div>
    </>
  )
}

// export default function (props, railsContext) {
//   return () => <BoxResizer {...props} />
// }
