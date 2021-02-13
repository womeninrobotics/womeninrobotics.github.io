function getCompareDate() {
  var d = new Date(),
    month = '' + (d.getMonth() + 1),
    day = '' + d.getDate(),
    year = d.getFullYear();
  if (month.length < 2) month = '0' + month;
  if (day.length < 2) day = '0' + day;
  return [year, month, day].join('');
}

$('[future-date]').each(function () {
  if ($(this).attr('future-date') < getCompareDate()) $(this).hide();
});

$('[past-date]').each(function () {
  if ($(this).attr('past-date') >= getCompareDate()) $(this).hide();
});
