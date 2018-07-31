const MODAL = "_drab_modal";
const MODAL_WRAPPER = "_drab_modal_wrapper";
const MODAL_BACKDROP = "_drab_modal_backdrop";
const MODAL_BUTTON_OK = "_drab_modal_button_ok";
const MODAL_BUTTON_CANCEL = "_drab_modal_button_cancel";
const MODAL_BUTTONS = ".drab-modal-button";

Drab.on_connect(function (resp, drab) {

  function clicked(message, element_name) {
    clearTimeout(Drab.modal_timeout_function);
    var modal = document.getElementById(MODAL);
    var modal_wrapper = document.getElementById(MODAL_WRAPPER);
    var modal_backdrop = document.getElementById(MODAL_BACKDROP);
    if (modal) {
      var form = modal.querySelector("form");
      var query_output = [message.sender, {
        button_clicked: element_name,
        params: Drab.form_params(form)
      }];
      drab.channel.push("modal", { ok: query_output });

      modal.className = "modal fade";
      modal_backdrop.className = "modal-backdrop fade";
      setTimeout(function () {
        modal_wrapper.outerHTML = "";
      }, 100);
    }
  }

  drab.channel.on("modal", function (message) {
    var modal, modal_backdrop;
    if (document.getElementById(MODAL_WRAPPER)) document.getElementById(MODAL_WRAPPER).outerHTML = "";
    document.querySelector("body").insertAdjacentHTML("beforeend", message.html);
    modal = document.getElementById(MODAL);
    modal_backdrop = document.getElementById(MODAL_BACKDROP);
    var form = modal.querySelector("form");
    setTimeout(function () {
      <%= case Drab.Config.get(:modal_css) do %>
        <% :bootstrap3 -> %> modal.classList.add("in"); modal_backdrop.classList.add("in");
        <% :bootstrap4 -> %> modal.classList.add("show"); modal_backdrop.classList.add("show");
      <% end %>
      form.querySelector("input, textarea, select").focus();
    }, 50);

    var buttons = modal.querySelectorAll(MODAL_BUTTONS);
    for (var i = 0; i < buttons.length; i++) {
      buttons[i].onclick = function (e) { clicked(message, e.srcElement.getAttribute("name"));}
    }
    form.onsubmit = function(e) {
      clicked(message, "ok");
      e.preventDefault();
      return false;
    };
    form.onkeyup = function(e) {
      var key = e.which || e.keyCode;
      if (key == 27) {
        clicked(message, "cancel");
      }
    }
    if (message.timeout) {
      Drab.modal_timeout_function = setTimeout(function () {
        clicked(message, "cancel");
      }, message.timeout);
    }
  });
});

