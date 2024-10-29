import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AppHighlightsComponent } from './app-highlights.component';

describe('AppHighlightsComponent', () => {
  let component: AppHighlightsComponent;
  let fixture: ComponentFixture<AppHighlightsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppHighlightsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AppHighlightsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
