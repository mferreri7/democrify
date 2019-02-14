import "bootstrap";
import 'select2/dist/css/select2.css';
import '../components/init_tooltip';
import Turbolinks from 'turbolinks';
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

Turbolinks.start();
