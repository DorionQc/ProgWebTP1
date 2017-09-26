
/* 
   Scripts of index page that aren't animations.
   Samuel Goulet & Gérémy Desmanche
   09-2017
 */

$(document).on("click", ".editable", function() {
  var original_text = $(this).text();
  var type = $(this).prop("tagName").toLowerCase();
  var id = $(this).attr("id");
  var newType = $(this).data().edittype;
  var new_input = $("<" + newType + " id =\"" + id + "\" class=\"editing\" data-type=\"" + type + "\"/>");
  new_input.val(original_text);
  $(this).replaceWith(new_input);
  new_input.focus();
});

$(document).on("blur", ".editing", function() {
  var new_input = $(this).val();
  var type = $(this).data().type;
  var id = $(this).attr("id");
  var editType = $(this).prop("tagName").toLowerCase();
  var updated_text = $("<" + type + " id =\"" + id + "\" class=\"editable canBeEditedEventually\" data-edittype=\"" + editType + "\">");
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
        $(".canBeEditedEventually").addClass("editable");
        $("#btnNew").val("Confirmer");
        $("#btnNew").off("click");
        $("#btnNew").click(confirmAdd);
    };
    
    var disableEdition = function(e) {
        e.stopPropagation();
        $(".canBeEditedEventually").removeClass("editable");
        $("#btnNew").val("Nouveau");
        $("#btnNew").off("click");
        $("#btnNew").click(enableEdition);
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
                action: "show",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            }
        });
        
    
    var getNext = function(e) {
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
    };
    
    var getPrev = function(e) {
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
            }
        });
        disableEdition(e);
    };
    
    var confirmAdd = function(e) {
        e.stopPropagation();
        var func = disableEdition.bind(this);
        func(e);
        
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "add",
                orderby: getOrder(),
                title: $("#txtTitle").html(),
                content: $("#txtText").html(),
                url: $("#txtUrl").html()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            }
        });
    };
    
    var updateStuff = function(data) {
        console.log(data);
        document.getElementById("content_img__img").src=data.imageUrl;
        $("#txtTitle").html(data.title);
        $("#txtText").html(data.content);
        $("#txtUrl").html(data.imageUrl);
        $("#txtScore").html(data.score);
    };
    
    var putSpinnerFunctionOnAnElement = function(element) {
        element.mouseenter(function() {
            rotate(360);
        }).mouseleave(function() {
            rotate(0, -5, 360);
        });
    };
    
    putSpinnerFunctionOnAnElement($("#footer"));
    putSpinnerFunctionOnAnElement($("#btnNext"));
    putSpinnerFunctionOnAnElement($("#content_img__img"));
    putSpinnerFunctionOnAnElement($("#bannerDiv"));
    
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
            }
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
            }
        });
        disableEdition(e);
    });
    
    $("#btnNext").click(getNext);
    
    $("#btnPrev").click(getPrev);
    
    $("#btnNextFooter").click(getNext);
    
    $("#btnPrevFooter").click(getPrev);
    
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
            }
        });
        
        disableEdition(e);
    });
    
    $("#btnUp").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "upvote",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            }
        });
        
        disableEdition(e);
    });
    
    $("#btnDown").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "downvote",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            }
        });
        
        disableEdition(e);
    });
    
    $("#btnFlag").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "flag",
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
            }
        });
        
        disableEdition(e);    
    });
    
    $("#btnSearch").click(function(e) {
        $.ajax({
            type: 'POST',
            url: 'Server/db-requests.jsp',
            data: {
                action: "search",
                title: $("#txtSearch").val(),
                orderBy: getOrder()
            },
            success: function(data) {
                updateStuff(data);
            },
            error: function(err) {
                console.log(err);
                document.getElementById("content_img__img").src="https://i2.wp.com/globalblurb.com/wp-content/uploads/2016/10/Fix-404-Not-Found-Error-In-WordPress.jpg?fit=404%2C404";
                $("#txtTitle").html("Pas de résultat!");
                $("#txtText").html("Impossible d'obtenir un résultat valide.");
                $("#txtUrl").html("https://i2.wp.com/globalblurb.com/wp-content/uploads/2016/10/Fix-404-Not-Found-Error-In-WordPress.jpg?fit=404%2C404");
                $("#txtScore").html("666");
            }
        });
        
        disableEdition(e);    
    });
});