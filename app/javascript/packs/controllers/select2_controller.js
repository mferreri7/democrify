import { Controller } from "stimulus"
import $ from 'jquery';
import 'select2';

export default class extends Controller {
  static targets = [ "multiSelect" ]

  connect() {
    this.select2mount()
  }

  select2mount() {
    $(this.multiSelectTarget).select2({
      width:'80%',
      tags: true,
      tokenSeparators: [';', ',', ' ']
    });
  }
}
