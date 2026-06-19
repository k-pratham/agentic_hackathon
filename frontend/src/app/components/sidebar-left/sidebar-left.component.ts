import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../core/auth.service';

@Component({
  selector: 'app-sidebar-left',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './sidebar-left.component.html',
  styleUrl: './sidebar-left.component.css'
})
export class SidebarLeftComponent {
  constructor(public authService: AuthService) {}

  logout() {
    this.authService.logout();
  }
}
