import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [status, setStatus] = useState('loading...');

  useEffect(() => {
    // This is the correct URL!
    const API_URL = 'http://k8s-default-backendi-6c2db33e75-309344880.us-east-1.elb.amazonaws.com'; 

    // The fetch call is now unblocked!
    fetch(`${API_URL}/status`)
      .then(res => {
        if (!res.ok) {
          throw new Error('Network response was not ok');
        }
        return res.json();
      })
      .then(data => {
        setStatus(`Backend says: DB is ${data.db}`);
      })
      .catch((err) => {
        console.error("Fetch error:", err);
        setStatus('Failed to connect to backend. Check browser console for CORS errors.');
      });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Welcome to K-Stax!</h1>
        <p>Your Full-Stack EKS Project is Live!</p>
        <p>API Status: <strong>{status}</strong></p>
      </header>
    </div>
  );
}

export default App;
