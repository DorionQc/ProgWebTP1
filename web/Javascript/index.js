
/* 
   Scripts of index page that aren't animations.
   Samuel Goulet & Gérémy Desmanche
   09-2017
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
    
    var enableEdition = function(e) {
        e.stopPropagation();
        console.log("Enable");
        $(".canBeEditedEventually").addClass("editable");
        $(this).val("Confirmer");
        $(this).off("click");
        $(this).click(confirmAdd);
    };
    
    var getOrder = function() {
        var order;
        if ($("#btnOrder").val() !== "Ordonner par score") {
            order = "Literally anything else";
        } else {
            order = "score";
        };
        return order;
    };
    
    $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "prev",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        
        
    var disableEdition = function(e) {
        e.stopPropagation();
        console.log("Disable");
        $(".canBeEditedEventually").removeClass("editable");
        $(this).val("Nouveau");
        $(this).off("click");
        $(this).click(enableEdition);
    };
    
    var confirmAdd = function(e) {
        e.stopPropagation();
        console.log("Add") ; 
        var func = disableEdition.bind(this);
        func(e);
        
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "add",
                orderby: getOrder(),
                title: $("#txtTitle").val(),
                content: $("#txtContent").val(),
                url: $("#txtUrl").val()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
    };
    
    var updateStuff = function(data) {
        console.log(data);
        console.log("yo");
        document.getElementById("content_img__img").src=data.imageUrl;
        $("#txtTitle").html(data.title);
        $("#txtText").html(data.content);
        $("#txtUrl").html(data.imageUrl);
        $("#txtScore").html(data.score);
    };
    
    $("#footer").mouseenter(function() {
        rotate(360);
    }).mouseleave(function() {
        rotate(0, -5, 360);
    });
    
    $("#btnNew").click(enableEdition);
    
    $("#btnFirst").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "first",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        disableEdition(e);
    });
    
    $("#btnLast").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "last",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        disableEdition(e);
    });
    
    $("#btnNext").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "next",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        disableEdition(e);
    });
    
    $("#btnPrev").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "prev",
                orderBy: getOrder() /* ($("#btnOrder").val() !== "Ordonner par score" ? "score" : "blugh") (Dafuq goulaah?)*/
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        disableEdition(e);
    });
    
    $("#btnOrder").click(function(e) {
        if ($("#btnOrder").val() !== "Ordonner par score") {
            $(this).val("Ordonner par score");
        } else {
            $(this).val("Ordonner par date");
        };
        
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "first",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            },
        });
        
        disableEdition(e);
    });
});