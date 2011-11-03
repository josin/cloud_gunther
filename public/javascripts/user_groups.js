$(function() {
   $("#user_group_user_tokens").tokenInput($("#user_group_user_tokens").data("users-path"), {
     crossDomain: false,
     prePopulate: $("#user_group_user_tokens").data("pre"),
     theme: "facebook"
   });
   
   $("#user_user_group_tokens").tokenInput($("#user_user_group_tokens").data("user-groups-path"), {
     crossDomain: false,
     prePopulate: $("#user_user_group_tokens").data("pre"),
     theme: "facebook"
   });
});
