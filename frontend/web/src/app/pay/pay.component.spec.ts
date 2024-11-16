import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PayComponent } from './pay.component';


describe('payComponent', () => {
  let component: PayComponent;
  let fixture: ComponentFixture<PayComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PayComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
