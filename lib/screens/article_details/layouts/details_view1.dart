import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_details/post_category.dart';
import 'package:news_app/screens/article_details/article_summary.dart';
import 'package:news_app/screens/article_details/author_info.dart';
import 'package:news_app/screens/article_details/bookmark_button.dart';
import 'package:news_app/screens/article_details/like_button.dart';
import 'package:news_app/screens/article_details/likes_count.dart';
import 'package:news_app/screens/article_details/post_back_button.dart';
import 'package:news_app/screens/article_details/post_share_button.dart';
import 'package:news_app/screens/article_details/post_source_button.dart';
import 'package:news_app/screens/article_details/related_articles.dart';
import '../../../ads/ad_manager.dart';
import '../../../ads/banner_ad.dart';
import '../../../components/html_body.dart';
import '../../../services/app_service.dart';
import '../../../utils/custom_cached_image.dart';
import '../article_tags.dart';
import '../comments_button.dart';
import '../date_and_reading_time.dart';
import '../views_count.dart';

class ArticleDetailsView1 extends ConsumerWidget {
  const ArticleDetailsView1({super.key, required this.article, this.heroTag});

  final Article article;
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initializing Insterstitail ads
    AdManager.initInterstitailAds(ref);
    debugPrint('state rebuild');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AdManager.isBannerEnbaled(ref) ? const BannerAdWidget() : null,
      body: SafeArea(
        bottom: true,
        top: false,
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              automaticallyImplyLeading: false,
              expandedHeight: 290,
              flexibleSpace: FlexibleSpaceBar(
                background: HeroMode(
                  enabled: heroTag != null,
                  child: Hero(
                    tag: heroTag ?? '',
                    child: CustomCacheImage(imageUrl: article.thumbnailUrl, radius: 0.0),
                  ),
                ),
              ),
              actions: [
                const PostBackButton(),
                const Spacer(),
                PostSourceButton(article: article),
                const SizedBox(width: 10),
                PostShareButton(article: article),
                const SizedBox(width: 10),
              ],
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          PostCategory(article: article),
                          const Spacer(),
                          LikeButton(article: article),
                          BookmarkButton(article: article),
                        ],
                      ),
                    ),
                    DateAndReadingTime(article: article),
                    Text(
                      AppService.getNormalText(article.title),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 1.5, letterSpacing: -0.3),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      endIndent: 280,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          ViewsCount(article: article),
                          const SizedBox(width: 20),
                          LikesCount(article: article),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AuthorInfo(article: article),
                        CommentsButton(article: article, ref: ref),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ArticleSummary(article: article),
                    HtmlBody(description: article.description),
                    const SizedBox(height: 20),
                    ArticleTags(article: article),
                    RelatedArticles(article: article),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
