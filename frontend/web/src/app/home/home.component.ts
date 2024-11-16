import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PayComponent } from '../pay/pay.component';
import { NewsletterComponent } from '../newsletter/newsletter.component';
import { HeroComponent } from '../hero/hero.component';
import { AppHighlightsComponent } from '../app-highlights/app-highlights.component';
import { CoachingComponent } from '../coaching/coaching.component';
import { UserReviewsComponent } from '../user-reviews/user-reviews.component';
import { HeaderComponent } from '../header/header.component';
import { FooterComponent } from '../footer/footer.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule,
    PayComponent,
    NewsletterComponent,
    HeroComponent,
    AppHighlightsComponent,
    CoachingComponent,
    UserReviewsComponent,
    HeaderComponent,
    FooterComponent
  ],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
})
export class HomeComponent {}
