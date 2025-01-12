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

export const NODE_ENVIRONMENT = 'production';

export const serverUrl = NODE_ENVIRONMENT === 'developement' ? 'http://localhost:8000' : 'https://server.development.payoor.store'
