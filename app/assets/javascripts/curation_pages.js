document.addEventListener("turbolinks:load", function(){
  setFieldValue();
  setInitialCategoryOptions();

  $('.category-option').click(function(e) {
    e.preventDefault();
    let value = JSON.parse($(this).attr("value"));
    $('#selected-categories').append(
      '<li class="list-group-item" id ="category-' + value.id + '" value=' + JSON.stringify(value) + ">" + 
        value.name +  
        '<a value=' + JSON.stringify(value) + ' class="delete btn btn-warning" href="#">remove</a>' +
      '</li>'
    );

    $('#category-options #category-' + value.id).hide();
    setFieldValue();
  });


  $('#selected-categories').on({
    click: function(e) {
      e.preventDefault();
      let value = JSON.parse($(this).attr("value"));
      $('#selected-categories #category-' + value.id).remove();
      $('#category-options #category-' + value.id).show();
      setFieldValue();
    }
  }, '.delete');

  function setFieldValue() {
    $('.selected-categories-field').val(JSON.stringify(""));
    let listItems = $('#selected-categories li');
    let arr = [];
    listItems.each(function(idx, li) {
      let value = JSON.parse($(li).attr("value"));
      arr.push(value.id);
    });
    $('.selected-categories-field').val(JSON.stringify(arr));
  }

  function setInitialCategoryOptions() {
    let listItems = $('#selected-categories li');
    listItems.each(function(idx, li) {
      let value = JSON.parse($(li).attr("value"));
      $('#category-options #category-' + value.id).hide();
    });
  }
});

