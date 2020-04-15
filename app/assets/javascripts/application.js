// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require popper
//= require turbolinks
//= require jquery

// required by the cork theme
//= require cork/bootstrap
//= require feather-icons/dist/feather
//= require perfect-scrollbar.min
//= require bootstrap-select.min
//= require cork/app

// project add-ons
// require froala-editor/js/froala_editor.min
//= require tinymce/tinymce.min


// initializers and quick add-ons
document.addEventListener("turbolinks:load", function() {
    App.init();
    feather.replace();
});
