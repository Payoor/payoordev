const isLocalhost = window.location.hostname.includes("localhost");

export const url = isLocalhost ? "http://localhost:3030" : "https://server.payoor.store";

export const service_url = isLocalhost ? "http://localhost:3031" : "https://socket.payoor.store";

export const search_url = isLocalhost ? "http://localhost:8084" : "https://llmserver.payoor.store";
