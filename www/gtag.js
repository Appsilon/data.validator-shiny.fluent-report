$(() => {

  /* Default installation */
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag('js', new Date());
  gtag('config', 'G-FQQZL5V93G');

  gtag('event', 'tab-open',{ tabname: 'main tab'});

  /* About Button */
  $('#navbar_section-about_section-open_modal').on('click', (event) => {
    gtag('event', 'about_button_clicked');
  });

  /* Let's Talk Button */
  $('#cta_talk').on('click', (event) => {
    gtag('event', 'lets_talk_clicked');
  });

  /* Appsilon Logo */
  $('.appsilon_logo').on('click', (event) => {
    gtag('event', 'appsilon_logo_clicked');
  });

  /* Code Tab */
  $('#Pivot5-Tab1').on('click', (event) => {
    gtag('event', 'tab-open',{ tabname: 'code tab'});
  });

  /* main Tab */
  $('#Pivot5-Tab0').on('click', (event) => {
    gtag('event', 'tab-open',{ tabname: 'main tab'});
  });

});
