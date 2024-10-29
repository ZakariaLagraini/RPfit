import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from './header/header.component';
import { HeroComponent } from './hero/hero.component';
import { AppHighlightsComponent } from './app-highlights/app-highlights.component';
import { CoachingComponent } from './coaching/coaching.component';
import { UserReviewsComponent } from './user-reviews/user-reviews.component';
import { PayComponent } from './pay/pay.component';
import { NewsletterComponent } from './newsletter/newsletter.component';
import { FooterComponent } from './footer/footer.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    HeaderComponent,
    HeroComponent,
    AppHighlightsComponent,
    CoachingComponent,
    UserReviewsComponent,
    PayComponent,
    NewsletterComponent,
    FooterComponent
  ],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'web-app';
}
