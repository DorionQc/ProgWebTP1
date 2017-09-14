/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).on("click", ".editable", function() {
  var original_text = $(this).text();
  var type = $(this).prop("tagName").toLowerCase();
  var newType = $(this).data().edittype;
  var new_input = $("<" + newType + " class=\"editing\" data-type=\"" + type + "\"/>");
  new_input.val(original_text);
  $(this).replaceWith(new_input);
  new_input.focus();
});

$(document).on("blur", ".editing", function() {
  var new_input = $(this).val();
  var type = $(this).data().type;
  var editType = $(this).prop("tagName").toLowerCase();
  var updated_text = $("<" + type + " class=\"editable\" data-edittype=\"" + editType + "\">");
  updated_text.text(new_input);
  $(this).replaceWith(updated_text);
});