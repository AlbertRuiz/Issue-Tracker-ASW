var onReady = function() {
    $('#mock-textarea').click(function () {
        $(this).addClass('hidden');
        $('#create-comment-wrapper').removeClass('hidden');
        $('#valid-textarea').focus();
    });

    $('#create-comment-back').click(function () {
        $('#create-comment-wrapper').addClass('hidden');
        $('#valid-textarea').val('');
        $('#mock-textarea').removeClass('hidden');
    });

    $('#menuUserImageButton').click(function (event) {
        event.preventDefault();
        $('#dropdown-menu').toggle();
    });

    $(window).click(function (event) {
        if(!event.target.matches('#menuUserImageButton')) $('#dropdown-menu').hide();
        if(!event.target.matches('.dropdown-wrapper') && !event.target.matches('.dropdown-btn')) $('.dropdown-wrapper').hide();
    });

    $('.edit-comment-btn').click(function () {
        var id = $(this).attr('comment-id');
        $('#comment_' + id + ' .edit-comment-form-wrapper').removeClass('hidden');
        $('#comment_' + id + ' .comment-buttons').addClass('hidden');
        $('#comment_' + id + ' .comment-description').addClass('hidden');
    });

    $('.cancel-edit-comment-btn').click(function () {
        var id = $(this).attr('comment-id');
        $('#comment_' + id + ' .edit-comment-form-wrapper').addClass('hidden');
        $('#comment_' + id + ' .comment-buttons').removeClass('hidden');
        $('#comment_' + id + ' .comment-description').removeClass('hidden');
    });

    $('.issues-table tr').off('mouseenter');
    $('.issues-table tr').off('mouseleave');
    $('.issues-table tr').on('mouseenter', function () {
        $(this).find('.watch-cell').removeClass('hidden');
    });
    $('.issues-table tr').on('mouseleave', function () {
        $(this).find('.watch-cell').addClass('hidden');
    });

    $('#workflow-btn').click(function (event) {
        event.preventDefault();
        $('#workflow-dropdown-btn').toggle();
    });

    $('#more-btn').click(function (event) {
        event.preventDefault();
        $('#more-dropdown-btn').toggle();
    });


    $('#assign-me-btn').click(function () {
        var id = $(this).attr('my_id');
        $('#form-asignee-select').find('option').removeAttr('selected');
        $('#form-asignee-select').val(id).change();
    });

    $('.attachment').off('mouseenter');
    $('.attachment').off('mouseleave');
    $('.attachment').on('mouseenter', function () {
        $(this).find('.delete-attachment-icon').removeClass('hidden');
    });
    $('.attachment').on('mouseleave', function () {
        $(this).find('.delete-attachment-icon').addClass('hidden');
    });
};


$(document).on('turbolinks:load', function() {
    $(document).ready(function () {
        onReady();
    });
});