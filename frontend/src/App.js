import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [status, setStatus] = useState('loading...');

  useEffect(() => {
    // IMPORTANT: Replace this with the DNS name of your Application Load Balancer
    // You will get this after the pipeline runs successfully and the ALB is created.
    const API_URL = 'http://YOUR_ALB_DNS_NAME_HERE'; 

    if (API_URL === 'http://YOUR_ALB_DNS_NAME_HERE') {
      setStatus('Please update the API_URL in frontend/src/App.js');
      return;
    }

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
