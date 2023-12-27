export class Layout {
    static minimizeSidebar(): void {
        (document.querySelector('.sidebar.maximized') as HTMLDivElement).classList.add('hidden');
        (document.querySelector('.sidebar.minimized') as HTMLDivElement).classList.add('visible');
    }

    static maximizeSidebar(): void {
        (document.querySelector('.sidebar.maximized') as HTMLDivElement).classList.remove('hidden');
        (document.querySelector('.sidebar.minimized') as HTMLDivElement).classList.remove('visible');
    }
}

export function setEventListeners() {
    (document.querySelector('button.nav-icon.minimize-sidebar') as HTMLButtonElement).onclick = Layout.minimizeSidebar;
    (document.querySelector('button.nav-icon.maximize-sidebar') as HTMLButtonElement).onclick = Layout.maximizeSidebar;
}

