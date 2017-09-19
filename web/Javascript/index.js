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
  if (this.parentElement.id === "content_url") {
      document.getElementById("content_img__img").src=new_input;
  }
  $(this).replaceWith(updated_text);
});

$(document).ready(function() {
    var rotate = function(degrees, step, current) {
        var self = $("#animatedText");
        current = current || 0;
        step = step || 5;
        current += step;
        self.css({
            '-webkit-transform' : 'rotate(' + current + 'deg)',
            '-moz-transform' : 'rotate(' + current + 'deg)',
            '-ms-transform' : 'rotate(' + current + 'deg)',
            'transform' : 'rotate(' + current + 'deg)'
        });
        if (current !== degrees) {
            setTimeout(function() {
                rotate(degrees, step, current);
            }, 5);
        }
    };
    
    var enableEdition = function() {
        console.log("Enable");
        $(".canBeEditedEventually").addClass("editable");
        $(this).val("Confirmer");
        $(this).click(disableEdition);
    };
    
    var disableEdition = function() {
        console.log("Disable");
        $(".canBeEditedEventually").removeClass("editable");
        $(this).val("Nouveau");
        $(this).click(enableEdition);
    };
    
    var updateStuff = function(data) {
        console.log("yo");
        document.getElementById("content_img__img").src=data.imageUrl;
        $("#txtTitle").val(data.title);
        $("#txtContent").val(data.content);
        $("#txtUrl").val(data.imageUrl);
        $("#txtScore").html(data.score);
    }
    
    $("#footer").mouseenter(function() {
        rotate(360);
    }).mouseleave(function() {
        rotate(0, -5, 360);
    });
    
    $("#btnNew").click(enableEdition);
    
    $("#btnFirst").click(function() {
        $.ajax({
            type: 'POST',
            url: 'db-request.jsp',
            data: {
                action: "first",
                orderBy: $("#btnOrder").data("order")
            },
            success: updateStuff,
        });
    });
    
    $("#btnLast").click(function() {
        $.ajax({
            type: 'POST',
            url: 'db-request.jsp',
            data: {
                action: "last",
                orderBy: $("#btnOrder").data("order")
            },
            success: updateStuff,
        });
    });
    
    $("#btnNext").click(function() {
        $.ajax({
            type: 'POST',
            url: 'db-request.jsp',
            data: {
                action: "next",
                orderBy: $("#btnOrder").data("order")
            },
            success: updateStuff,
        });
    });
    
    $("#btnPrev").click(function() {
        $.ajax({
            type: 'POST',
            url: 'db-request.jsp',
            data: {
                action: "prev",
                orderBy: ($("#btnOrder").val() !== "Ordonner par score" ? "score" : "blugh")
            },
            success: updateStuff,
        });
    });
    
    $("#btnOrder").click(function() {
        if ($("#btnOrder").val() !== "Ordonner par score") {
            $(this).val("Ordonner par score");
        } else {
            $(this).val("Ordonner par date");
        };
        
        $.ajax({
            type: 'POST',
            url: 'db-request.jsp',
            data: {
                action: "first",
                orderBy: $("#btnOrder").data("order")
            },
            success: updateStuff,
        });
    });
});