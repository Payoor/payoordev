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
