import { Controller } from "stimulus"
import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

export default class extends Controller {
  static targets = [ "multiSelect" ]

  connect() {
    this.select2mount()
  }

  select2mount() {
    $(this.multiSelectTarget).select2({
      tags: true,
      tokenSeparators: [';', ',', ' ']
    });
  }
}
