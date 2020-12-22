
<div class="slidercarousel">
	@imageSliderContent@
</div>
<script type="text/javascript">
	$(document).ready(function(){
	  $('.slidercarousel').slick({
		  infinite: true,
		  slidesToShow: @show_items@,
		  slidesToScroll: 1,
		  autoplay: true,
		  autoplaySpeed: 2000
	  });
	});
 </script>
 <style>
 .c_item {
 display:flex;
 justify-content:center;

 }
  .c_item img {
height:90px;
max-width:250px;
  }
  .slick-slide {
  display:flex!important;
  justify-content:center;
  align-items:center;
  }
  .slick-track {
  display: flex;
    align-items: center;
  }
 </style>
