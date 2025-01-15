import React, { useState } from "react";

function App() {
  const [result, setResult] = useState("");

  const runRScript = async () => {
    const response = await fetch("https://jobs-apply-2.onrender.com/run-r-script", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        params: [5, "Hello from React!"],
      }),
    });

    const data = await response.json();
    setResult(data.output);
  };

  return (
    <div>
      <h1>Run R Script from React</h1>
      <button onClick={runRScript}>Run Script</button>
      <p>Output: {result}</p>
    </div>
  );
}

export default App;
