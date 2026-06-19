import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../core/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  email: string = '';
  error: string = '';
  loading: boolean = false;

  constructor(private authService: AuthService) {}

  onSubmit() {
    if (!this.email.trim()) return;
    this.loading = true;
    this.error = '';
    
    this.authService.login(this.email).subscribe({
      next: () => {
        this.loading = false;
      },
      error: (err) => {
        this.loading = false;
        this.error = err.error?.detail || 'Login failed. Please check your email.';
      }
    });
  }
}
