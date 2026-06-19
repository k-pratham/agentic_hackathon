import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, tap } from 'rxjs';

export interface UserState {
  person_id: number;
  person_name: string;
  dept_id: number;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  public user = signal<UserState | null>(null);

  constructor(private http: HttpClient, private router: Router) {
    const saved = localStorage.getItem('user');
    if (saved) {
      this.user.set(JSON.parse(saved));
    }
  }

  login(email: string): Observable<any> {
    return this.http.post<any>('/api/v1/login', { email, password: '' }).pipe(
      tap(res => {
        if (res.status === 'success') {
          const userState = {
            person_id: res.person_id,
            person_name: res.person_name,
            dept_id: res.dept_id
          };
          this.user.set(userState);
          localStorage.setItem('user', JSON.stringify(userState));
          this.router.navigate(['/']);
        }
      })
    );
  }

  logout() {
    this.user.set(null);
    localStorage.removeItem('user');
    this.router.navigate(['/login']);
  }
}
