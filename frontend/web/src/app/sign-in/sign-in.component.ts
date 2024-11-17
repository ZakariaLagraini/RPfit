import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-sign-in',
  standalone: true,
  imports: [RouterModule],
  templateUrl: './sign-in.component.html',
  styleUrl: './sign-in.component.css'
})
export class SignInComponent {
  constructor(private location: Location) {}

  goBack(): void {
    this.location.back();
  }
}
