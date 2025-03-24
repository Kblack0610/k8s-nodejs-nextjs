'use client';

import React, { useState, useEffect } from 'react';

// Define the type for the API response
interface ApiResponse {
  message: string;
  data?: Array<{
    id: string | number;
    name: string;
  }>;
}

export default function Home() {
  const [data, setData] = useState<ApiResponse | null>(null);
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    // Use relative URL to leverage Next.js API routing/rewrites
    fetch('/api/data')
      .then((res) => res.json())
      .then((data: ApiResponse) => {
        setData(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error('Error fetching data:', error);
        setLoading(false);
      });
  }, []);

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm">
        <h1 className="text-4xl font-bold mb-8">Kubernetes Next.js + Node.js Demo</h1>
        
        <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
          <h2 className="text-2xl font-semibold mb-4">Backend Data:</h2>
          
          {isLoading ? (
            <p>Loading data from backend...</p>
          ) : data ? (
            <div>
              <p className="mb-2">{data.message}</p>
              <ul className="list-disc pl-5">
                {data.data && data.data.map((item) => (
                  <li key={item.id} className="mb-1">{item.name}</li>
                ))}
              </ul>
            </div>
          ) : (
            <p className="text-red-500">Failed to load data</p>
          )}
        </div>
      </div>
    </main>
  );
}
