import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/enquiries/domain/enquiry.dart';
import 'package:vendoros/features/feedback/domain/feedback_entry.dart';
import 'package:vendoros/features/feedback/domain/feedback_link.dart';
import 'package:vendoros/features/offers/domain/offer.dart';

void main() {
  group('offers', () {
    test('flat, percent and combo discounts stay inside the bill', () {
      const flat = Offer(id: 'a', name: 'Ten off', valuePaise: 1000);
      const pct =
          Offer(id: 'b', name: 'Ten pc', kind: OfferKind.percent, percent: 10);
      const combo =
          Offer(id: 'c', name: 'Combo', kind: OfferKind.combo, valuePaise: 8000);
      expect(flat.discountOn(5000), 1000);
      expect(flat.discountOn(500), 500);
      expect(pct.discountOn(5000), 500);
      expect(combo.discountOn(10000), 2000);
      expect(combo.discountOn(0), 0);
    });

    test('profit after an offer can go negative', () {
      expect(
        profitAfterOffer(
            subtotalPaise: 10000, costPaise: 7000, discountPaise: 1000),
        2000,
      );
      expect(
        profitAfterOffer(
            subtotalPaise: 10000, costPaise: 9500, discountPaise: 1000),
        -500,
      );
    });

    test('redemption totals average out and round-trip', () {
      const o = Offer(
          id: 'a', name: 'Ten off', redemptions: 4, discountedPaise: 4200);
      expect(o.avgDiscountPaise, 1050);
      expect(totalDiscounted([o, o]), 8400);
      final back = Offer.tryFromJson(o.toJson());
      expect(back?.discountedPaise, 4200);
      expect(Offer.tryFromJson({'id': '', 'name': 'x'}), isNull);
    });
  });

  group('feedback', () {
    FeedbackEntry at(FeedbackRating r, DateTime t) => FeedbackEntry(
        id: '${t.microsecondsSinceEpoch}$r',
        ts: t.millisecondsSinceEpoch,
        rating: r);

    test('averages cover only the asked-for days', () {
      final now = DateTime(2026, 5, 10, 12);
      final entries = [
        at(FeedbackRating.happy, now),
        at(FeedbackRating.okay, now),
        at(FeedbackRating.unhappy, now.subtract(const Duration(days: 20))),
      ];
      expect(feedbackOn(entries, now).length, 2);
      expect(averageScore(feedbackOn(entries, now)), 2.5);
      expect(recentFeedback(entries, now: now).length, 2);
      expect(averageScore(const []), 0);
    });

    test('only unhappy notes need a reply', () {
      final now = DateTime(2026, 5, 10, 12);
      final entries = [
        at(FeedbackRating.happy, now),
        at(FeedbackRating.unhappy, now),
      ];
      expect(needsReply(entries).single.rating, FeedbackRating.unhappy);
    });

    test('the QR link carries shop, phone and review target', () {
      final url = feedbackUrl(
        baseUrl: 'https://shop.example.com/',
        shopName: 'Amma Tea',
        phone: '9876543210',
        reviewUrl: 'https://g.page/r/x',
      );
      expect(url, startsWith('https://shop.example.com/m/feedback.html?'));
      expect(url, contains('n=Amma+Tea'));
      expect(url, contains('p=9876543210'));
      expect(feedbackUrl(baseUrl: '', shopName: 'X'),
          startsWith('https://sirpam.app/m/feedback.html'));
    });
  });

  group('enquiries', () {
    Enquiry e(String id, EnquiryStatus s, {String due = ''}) => Enquiry(
        id: id,
        name: 'C$id',
        status: s,
        followUpDay: due,
        quotedPaise: 5000,
        createdAt: 1);

    test('filters split follow-ups, open, won and lost', () {
      final now = DateTime(2026, 5, 10, 12);
      final rows = [
        e('1', EnquiryStatus.open, due: '2026-05-10'),
        e('2', EnquiryStatus.open),
        e('3', EnquiryStatus.won),
        e('4', EnquiryStatus.lost),
      ];
      expect(filterEnquiries(rows, EnquiryFilter.today, now: now).length, 1);
      expect(filterEnquiries(rows, EnquiryFilter.open, now: now).length, 2);
      expect(filterEnquiries(rows, EnquiryFilter.won, now: now).single.id, '3');
      expect(filterEnquiries(rows, EnquiryFilter.lost, now: now).single.id, '4');
    });

    test('win rate and won value read only closed enquiries', () {
      final rows = [
        e('1', EnquiryStatus.won),
        e('2', EnquiryStatus.lost),
        e('3', EnquiryStatus.open),
      ];
      expect(enquiryWinRate(rows), 0.5);
      expect(wonValuePaise(rows), 5000);
      expect(enquiryWinRate(const []), 0);
    });
  });
}
