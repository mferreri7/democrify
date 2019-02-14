import { Controller } from "stimulus"
import $ from 'jquery';

export default class extends Controller {

  connect() {
    this.mountTooltips()
  }

  mountTooltips(){
    $(this.element).tooltip()
  }
}
