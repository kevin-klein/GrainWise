// frontend/src/components/ImportProgress.jsx
import React from 'react'
import MessageBus from '../message-bus'

export default function ImportProgress ({ lastID }) {
  const [messages, setMessages] = React.useState([])

  React.useEffect(() => {
    MessageBus.start()

    const unsubscribe = MessageBus.subscribe(
      '/importprogress',
      (data) => {
        // The payload is now either a string, an object `{progress: …}` or `{error: …}`
        setMessages((old) => [...old, data])
      },
      lastID
    )

    // Clean up on unmount
    return () => {
      unsubscribe()
      MessageBus.stop()
    };
  }, [lastID])

  return (
    <div className='row'>
      <div className='col-md-3' />
      <div className='col-md-6'>
        {messages.map((message, idx) => {
          // 1️⃣  Render an error banner
          if (message.error) {
            return (
              <div key={idx} className='alert alert-danger' role='alert'>
                <strong>⚠️  Import failed</strong>
                <p>{message.error}</p>
                {message.backtrace && (
                  <pre className='mb-0'>{message.backtrace.join('\n')}</pre>
                )}
              </div>
            )
          }

          // 2️⃣  Render progress / text as before
          if (message.progress !== undefined) {
            return (
              <React.Fragment key={idx}>
                <div>Analyzing Page Content</div>
                <div className='progress'>
                  <div
                    className='progress-bar'
                    style={{ width: `${message.progress * 100}%` }}
                  />
                </div>
              </React.Fragment>
            )
          }

          return (
            <div key={idx} className='text-muted'>
              {typeof message === 'string' ? message : JSON.stringify(message)}
            </div>
          )
        })}
      </div>
    </div>
  )
}
