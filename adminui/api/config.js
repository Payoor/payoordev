export const getDefaultHeader = () => {
  return {
    headers: {
      Authorization: 'Bearer ' + localStorage.getItem('adminToken'),
    }
  }
};

export const getUserHeader = () => {
  return {
    headers: {
      Authorization: 'Bearer ' + localStorage.getItem('payoor_user_token'),
    }
  }
};

export const getFileHeader = () => {
  return {
    headers: {
      'Authorization': 'Bearer ' + localStorage.getItem('adminToken'),
      'Content-Type': 'multipart/form-data'
    }
  }
};

const isClient = typeof window !== 'undefined';
const isLocalhost = isClient ? window.location.hostname.includes("localhost") : process.env.NODE_ENV === 'development';

export const serverUrl = isLocalhost ? "http://localhost:3030" : "https://server.payoor.store";


//export const serverUrl = 'http://localhost:3030';

//export const serverUrl = 'https://server.payoor.store';

