export class Layout {
    static insertSidebarModal() {
        const content: HTMLDivElement = document.querySelector('#content')!;
        const sidebarModal: HTMLDivElement = document.createElement('div');
        sidebarModal.classList.add('sidebar-modal');
        const sidebar: HTMLDivElement = document.createElement('div');
        sidebar.classList.add('sidebar');
        sidebarModal.appendChild(sidebar);
        content.appendChild(sidebarModal); 
    }

    static expandSidebar() {
        setTimeout(() => {
            (document.querySelector('.sidebar') as HTMLDivElement).classList.add('expanded');

        (document.querySelector('.sidebar-modal') as HTMLDivElement).onclick = Layout.exitModal;
        }, 0);
    }

    static showSidebar() {
        Layout.insertSidebarModal();
        Layout.expandSidebar();
    }

    static exitModal(e: Event) {
        const sidebar: HTMLDivElement = document.querySelector('.sidebar.expanded')!;
        const sidebarModal: HTMLDivElement = document.querySelector('.sidebar-modal')!;
        if (e.target === sidebar) {
            return;
        } else {
            sidebar.classList.remove('expanded');
            const transitionDuration: number = getTransitionDuration(sidebar);
            setTimeout(() => {
                if (sidebarModal.parentNode) {
                    sidebarModal.parentNode.removeChild(sidebarModal);
                }
            }, transitionDuration);
        }

        function getTransitionDuration(element: HTMLElement): number {
            const duration = window.getComputedStyle(element).transitionDuration;
            return Number(duration.split('s')[0]) * 1000;
        }
    }
}
