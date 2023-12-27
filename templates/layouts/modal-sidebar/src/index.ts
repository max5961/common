import './style/index.scss';
import { Layout } from './controller';

(document.querySelector('button.show-sidebar') as HTMLButtonElement).onclick = Layout.showSidebar;
