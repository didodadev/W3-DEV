import './assets/css/kothing-editor.css'
import './assets/css/kothing-editor-contents.css'

import plugins from './plugins'
import KothingEditor from './editor'

window.KothingEditor = KothingEditor.init({
  plugins: plugins,
})
