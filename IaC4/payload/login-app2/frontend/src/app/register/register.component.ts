import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css'],
  standalone: false,
})
export class RegisterComponent {
  username: string = '';
  password: string = '';
  message: string = '';
  constructor(private http: HttpClient, private router: Router) {}
  register() {
    const credentials = { username: this.username, password: this.password };
    this.http.post(`${environment.apiUrl}/register`, credentials).subscribe(
      (response: any) => {
        this.message = response.message;
        if (response.success) {
          setTimeout(() => {
            this.router.navigate(['/login']); // Redirect to login page after successful registration
          }, 2000);
        }
      },
      (error) => {
        this.message = 'Registration failed';
      }
    );
  }
}
