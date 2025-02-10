import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  standalone: false,
})
export class LoginComponent {
  username: string = '';
  password: string = '';
  message: string = '';
  constructor(private http: HttpClient) {}
  login() {
    const credentials = { username: this.username, password: this.password };
    this.http.post(`${environment.apiUrl}/login`, credentials).subscribe(
      (response: any) => {
        this.message = response.message;
      },
      (error) => {
        this.message = 'Login failed';
      }
    );
  }
}
