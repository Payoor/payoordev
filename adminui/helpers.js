export const formatAmount = (amount) => {
  const formatter = new Intl.NumberFormat("en-NG", {
    style: "currency",
    currency: "NGN",
    minimumFractionDigits: 0,
  });

  return formatter.format(amount);
}

export const timestampToDateString = (timestamp) => {
  return new Date(timestamp).toLocaleString('en-gb', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

export const isDate = (value) => {
  if (typeof value !== "string") return false;

  // Check if the string can be converted to a valid Date
  const date = new Date(value);
  return !isNaN(date.getTime());
}

export const formatTime = (timestamp) => {
  const date = new Date(timestamp);
  const hours = date.getHours();
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const period = hours >= 12 ? 'pm' : 'am';

  // Convert hours to 12-hour format
  const formattedHours = hours % 12 || 12;

  return `${formattedHours}:${minutes}${period}`;
}
