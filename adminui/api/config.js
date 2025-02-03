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

export const NODE_ENVIRONMENT = 'development';

export const serverUrl = NODE_ENVIRONMENT === 'development' ? 'http://localhost:3030' : 'https://server.payoor.store'
