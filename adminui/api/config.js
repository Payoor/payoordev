export const getDefaultHeader = () => {
  return {
    headers: {
      Authorization: 'Bearer ' + localStorage.getItem('adminToken'),
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

export const serverUrl = 'http://localhost:3030'//'https://server.development.payoor.store';
