$.fn.isInViewport = function () {
    var elementTop = $(this).offset().top;
    var elementBottom = elementTop + $(this).outerHeight();

    var viewportTop = $(window).scrollTop();
    var viewportBottom = viewportTop + $(window).height();

    return elementBottom > viewportTop && elementTop < viewportBottom;
};

$('.timer').each(function () {
    var myVar = setInterval(startCheck, 500);
    $(this).text(0);
    function startCheck() {
        if ($('.timer').isInViewport()) {
            clearInterval(myVar);
            $('.timer').countTo({
                refreshInterval: 60,
                formatter: function (value, options) {
                    return value.toFixed(options.decimals);
                },
            });
        }
    }
});
