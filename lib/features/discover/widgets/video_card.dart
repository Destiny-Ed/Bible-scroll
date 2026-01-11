// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:myapp/features/discover/widgets/comments_modal_sheet.dart';

// class VideoCard extends StatefulWidget {
//   final String videoUrl;
//   final String title;
//   final String uploader;
//   final String avatarUrl;
//   final bool isLiked;

//   const VideoCard({
//     super.key,
//     required this.videoUrl,
//     required this.title,
//     required this.uploader,
//     required this.avatarUrl,
//     this.isLiked = false,
//   });

//   @override
//   State<VideoCard> createState() => _VideoCardState();
// }

// class _VideoCardState extends State<VideoCard> with TickerProviderStateMixin {
//   late VideoPlayerController _controller;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool _isLiked = false;
//   bool _showLikeEffect = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {}); // Ensure the first frame is shown
//         _controller.setLooping(true);
//       });

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

//     _isLiked = widget.isLiked;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//     });
//   }

//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked;
//       if (_isLiked) {
//         _showLikeEffect = true;
//         _animationController.forward(from: 0).then((_) {
//           setState(() {
//             _showLikeEffect = false;
//           });
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: _toggleLike,
//       onTap: _togglePlayPause,
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         elevation: 4,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             if (_controller.value.isInitialized)
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             else
//               const Center(child: CircularProgressIndicator()),
//             if (!_controller.value.isPlaying)
//               const Icon(Icons.play_arrow, color: Colors.white, size: 80),
//             _buildVideoOverlay(context),
//             _buildActionButtons(context),
//             if (_showLikeEffect)
//               AnimatedBuilder(
//                 animation: _animation,
//                 builder: (context, child) {
//                   return Icon(
//                     Icons.favorite,
//                     color: Colors.red.withAlpha(
//                       (255 * _animation.value).toInt(),
//                     ),
//                     size: 100 * _animation.value,
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoOverlay(BuildContext context) {
//     return Positioned.fill(
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.transparent, Colors.black.withAlpha(178)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(widget.avatarUrl),
//                     radius: 16,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     widget.uploader,
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Positioned(
//       right: 10,
//       bottom: 100,
//       child: Column(
//         children: [
//           IconButton(
//             icon: Icon(
//               _isLiked ? Icons.favorite : Icons.favorite_border,
//               color: _isLiked ? Colors.red : Colors.white,
//             ),
//             onPressed: _toggleLike,
//           ),
//           const Text('Like', style: TextStyle(color: Colors.white)),
//           const SizedBox(height: 20),
//           IconButton(
//             icon: const Icon(Icons.comment, color: Colors.white),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) => const CommentsModalSheet(),
//               );
//             },
//           ),
//           const Text('Comment', style: TextStyle(color: Colors.white)),
//           const SizedBox(height: 20),
//           IconButton(
//             icon: const Icon(Icons.share, color: Colors.white),
//             onPressed: () {},
//           ),
//           const Text('Share', style: TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }
