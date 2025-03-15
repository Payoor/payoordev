const isClient = typeof window !== 'undefined';
const isLocalhost = isClient ? window.location.hostname.includes("localhost") : process.env.NODE_ENV === 'development';

export const url = isLocalhost ? "http://localhost:3030" : "https://server.payoor.store";

export const service_url = isLocalhost ? "http://localhost:3031" : "https://socket.payoor.store";

export const search_url = isLocalhost ? "http://localhost:8084" : "https://llmserver.payoor.store";