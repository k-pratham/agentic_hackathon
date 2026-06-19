import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { MainLayoutComponent } from './components/main-layout/main-layout.component';
import { authGuard } from './core/auth.guard';

export const routes: Routes = [
  { path: '', component: MainLayoutComponent, canActivate: [authGuard] },
  { path: 'login', component: LoginComponent },
  { path: '**', redirectTo: '' }
];
