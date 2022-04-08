// document.addEventLister('turbolinks:load',function() {
//   document.querySelectorAll('td').forEach(function(td) {
//     td.addEventListener('mouseover',function(e) {
//       e.currentTarget.style.backgroundColor = '#eff';
//     }); 
    
//     td.addEventListener('mouseout', function(e) {
//       e.currentTarget.style.buckgroundColor = '';
//     });
//   });
// });

document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.delete').forEach(function(a) {
    a.addEventListener('ajax:success',function() {
      var td = a.parentNode;
      var tr = td.parentNode;
      // trのスタイルを変更して、非表示
      tr.style.display = 'none';
    });
  });
});