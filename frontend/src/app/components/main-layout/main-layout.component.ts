import { Component } from '@angular/core';
import { SidebarLeftComponent } from '../sidebar-left/sidebar-left.component';
import { ChatAreaComponent } from '../chat-area/chat-area.component';

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [SidebarLeftComponent, ChatAreaComponent],
  templateUrl: './main-layout.component.html',
  styleUrl: './main-layout.component.css'
})
export class MainLayoutComponent {
}
