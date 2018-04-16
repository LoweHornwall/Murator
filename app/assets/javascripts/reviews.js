document.addEventListener("turbolinks:load", function(){
	$('#search_result').on({
    click: function() {
      let prev = parseInt($("#page").val());
      $("#page").val(prev + 1);
    }
  }, "#next");
  $('#search_result').on({
    click: function() {
      let prev = parseInt($("#page").val());
      $("#page").val(prev - 1);
    }
  }, "#prev");
  $('#search_result').on({
    click: function(e) {
      e.preventDefault();
      let value = JSON.parse($(this).attr("value"));
      $(".selected_release_name").val(value.release);
      $(".rgid").val(value.rgid);

    }
  }, ".select");
  $("#submit").click(function() {
    $("#page").val(1);
  })

});

